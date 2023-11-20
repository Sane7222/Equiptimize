using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Http;
using System.Text.RegularExpressions;
using HtmlAgilityPack;

namespace Web_Scraper {
    internal class Program {
        static void Main(string[] args) {
            // test();

            // Connect to the SQL Server database
            string connString = ConfigurationManager.ConnectionStrings["Web_Scraper.Properties.Settings.equiptimize"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString)) {
                connection.Open();

                // InsertOperations(connection);
                // InsertAttributes(connection);

                UpdateRaces(connection); // Racial Passives
                // UpdateClasses(connection); // Class Skill Trees
                // UpdateMundus(connection); // Mundus Effects
                // UpdateChampion(connection); // How many stages
                // UpdateSets(connection); // Fifth Piece
                // UpdateSkills(connection); // Default, Class, Race

                connection.Close();
            }
        }

        private static void UpdateSkills(SqlConnection conn) {
            HtmlDocument doc = GetDocument("https://eso-hub.com/en/");
        }

        private static void InsertOperations(SqlConnection conn) {
            SqlCommand command = new SqlCommand("INSERT INTO operation (op) VALUES ('+'), ('-'), ('*'), ('/')", conn);
            command.ExecuteNonQuery();
        }

        // https://en.uesp.net/wiki/Special:EsoBuildEditor
        private static void InsertAttributes(SqlConnection conn) {
            SqlCommand command = new SqlCommand("INSERT INTO attribute (attr_name, attr_value) VALUES " +
                                                "('Health', 16000), ('Magicka', 12000), ('Stamina', 12000), " +
                                                "('Health Recovery', 309), ('Magicka Recovery', 514), ('Stamina Recovery', 514), " +
                                                "('Spell Damage', 1000), ('Weapon Damage', 1000), " +
                                                "('Spell Critical', 0.1), ('Weapon Critical', 0.1), " +
                                                "('Spell Critical Damage', 0.5), ('Weapon Critical Damage', 0.5), " +
                                                "('Spell Resistance', 0), ('Physical Resistance', 0), ('Critical Resistance', 1320)," +
                                                "('Spell Penetration', 0), ('Physical Penetration', 0), " +
                                                "('Healing Done', 1.0), ('Healing Taken', 1.0), " +
                                                "('Damage Done', 1.0), ('Damage Taken', 1.0), " +
                                                "('Oblivion Flat', 0), ('Oblivion Percent', 1.0), " +
                                                "('Magic Flat', 0), ('Magic Percent', 1.0), " +
                                                "('Physical Flat', 0), ('Physical Percent', 1.0), " +
                                                "('Fire Flat', 0), ('Fire Percent', 1.0), ('Fire Resistance', 0), " +
                                                "('Frost Flat', 0), ('Frost Percent', 1.0), ('Frost Resistance', 0), " +
                                                "('Shock Flat', 0), ('Shock Percent', 1.0), ('Shock Resistance', 0), " +
                                                "('Bleed Flat', 0), ('Bleed Percent', 1.0), ('Bleed Resistance', 0), " +
                                                "('Disease Flat', 0), ('Disease Percent', 1.0), ('Disease Resistance', 0), " +
                                                "('Poison Flat', 0), ('Poison Percent', 1.0), ('Poison Resistance', 0)", conn);
            command.ExecuteNonQuery();
        }

        private static void UpdateSets(SqlConnection conn) { // Outputs: Name, Desc
            HtmlDocument doc = GetDocument("https://eso-hub.com/en/sets/all");

            string pName = @"&[^&;]+;";

            var table = doc.GetElementbyId("searchable-table-sets"); // Sets table

            foreach (var row in table.Descendants("tr")) { 
                if (row.SelectSingleNode("td/small").InnerText.Equals("Unknown")) continue; // Skip unobtainable sets

                // Name and description
                string name = row.SelectSingleNode("td/a").InnerText.Trim();
                name = Regex.Replace(name, pName, "");
                string desc = row.SelectSingleNode("td[3]").InnerText.Trim();

                using (SqlCommand command = new SqlCommand("SELECT set_desc FROM [set] WHERE set_name = @name", conn)) {
                    command.Parameters.AddWithValue("@name", name);
                    string dbDesc = (string) command.ExecuteScalar();

                    if (dbDesc == null) { // Set not found in DB, so insert it
                        using (SqlCommand insertCommand = new SqlCommand("INSERT INTO [set] (set_name, set_desc) VALUES (@name, @desc)", conn)) {
                            insertCommand.Parameters.AddWithValue("@name", name);
                            insertCommand.Parameters.AddWithValue("@desc", desc);
                            insertCommand.ExecuteNonQuery();
                        }
                        SetEffects(conn, desc);
                    } else if (dbDesc != desc) { // New set description, so update it
                        using (SqlCommand updateCommand = new SqlCommand("UPDATE [set] SET set_desc = @desc WHERE set_name = @name", conn)) {
                            updateCommand.Parameters.AddWithValue("@name", name);
                            updateCommand.Parameters.AddWithValue("@desc", desc);
                            updateCommand.ExecuteNonQuery();
                        }
                        SetEffects(conn, desc);
                    }
                }
            }
        }

        private static void SetEffects(SqlConnection conn, string desc) { // Outputs: Static set bonuses
            string pDesc = "\\([^\\)]*\\)";
            string pItem = @"\((\d+) item|items\)";
            int index = 0;

            Regex[] regex = {
                new Regex(@"^Adds (?<value>\d+) (?<keyword>Health Recovery|Magicka Recovery|Stamina Recovery)$", RegexOptions.Compiled),
                new Regex(@"^Adds (?<value>\d+) Maximum (?<keyword>Health|Magicka|Stamina)$", RegexOptions.Compiled),
                new Regex(@"^Adds (?<value>\d+) (?<keyword>Armor|Offensive Penetration|Weapon and Spell Damage)$", RegexOptions.Compiled),
                new Regex(@"^Adds (?<value>\d+)% (?<keyword>Healing Taken|Healing Done)$", RegexOptions.Compiled),
                new Regex(@"^Adds (?<value>\d+) (?<keyword>Critical Chance|Critical Resistance)$", RegexOptions.Compiled),
                new Regex(@"^Gain Minor (?<keyword>Aegis|Slayer) at all times, (?:reducing|increasing) your damage (?:taken from|done to) Dungeon, Trial, and Arena Monsters by (?<value>\d+)%\.$", RegexOptions.Compiled),
            };

            Dictionary<string, string[]> keyAttrPairs = new Dictionary<string, string[]> {
                { "Armor", new string[] { "Spell Resistance", "Physical Resistance" } },
                { "Offensive Penetration", new string[] { "Spell Penetration", "Physical Penetration" } },
                { "Weapon and Spell Damage", new string[] { "Weapon Damage", "Spell Damage" } },
                { "Critical Chance", new string[] { "Weapon Critical", "Spell Critical" } },
                { "Aegis", new string[] { "Damage Taken" } },
                { "Slayer", new string[] { "Damage Done" } }
            };

            // Set ID
            int setID;
            using (SqlCommand command = new SqlCommand("SELECT set_id FROM [set] WHERE set_desc = @desc", conn)) {
                command.Parameters.AddWithValue("@desc", desc);
                setID = (int) command.ExecuteScalar();
            }

            // Remove all occurances for updating and inserting
            using (SqlCommand command = new SqlCommand("DELETE FROM set_effect WHERE set_id = @set", conn)) {
                command.Parameters.AddWithValue("@set", setID);
                command.ExecuteNonQuery();
            }

            // Get the effects item count
            MatchCollection matches = Regex.Matches(desc, pItem);
            List<int> items = new List<int>();
            foreach (Match entry in matches) items.Add(int.Parse(entry.Groups[1].Value));

            string[] effects = Regex.Split(desc, pDesc).Skip(1).Select(x => x.Trim()).ToArray(); // Split the description into effects
            foreach (string effect in effects) {
                var entry = regex.FirstOrDefault(x => x.Match(effect).Success);

                if (entry != null) {
                    Match match = entry.Match(effect);
                    string keyword = match.Groups["keyword"].Value;
                    float value = float.Parse(match.Groups["value"].Value);
                    if (effect.Contains("%")) value /= 100;

                    // Operation ID
                    string op = keyword == "Aegis" ? "-" : "+";
                    Int16 opID;
                    using (SqlCommand command = new SqlCommand("SELECT op_id FROM operation WHERE op = @op", conn)) {
                        command.Parameters.AddWithValue("@op", op);
                        opID = (Int16) command.ExecuteScalar();
                    }

                    string[] attrs = keyAttrPairs.ContainsKey(keyword) ? keyAttrPairs[keyword] : new string[] { keyword };
                    foreach (string attr in attrs) {

                        // Attribute ID
                        Int16 attrID;
                        using (SqlCommand command = new SqlCommand("SELECT attr_id FROM attribute WHERE attr_name = @attr", conn)) {
                            command.Parameters.AddWithValue("@attr", attr);
                            attrID = (Int16) command.ExecuteScalar();
                        }

                        using (SqlCommand insertCommand = new SqlCommand("INSERT INTO set_effect (set_id, items, op_id, value, attr_id) VALUES (@set, @item, @op, @value, @attr)", conn)) {
                            insertCommand.Parameters.AddWithValue("@set", setID);
                            insertCommand.Parameters.AddWithValue("@item", items[index]);
                            insertCommand.Parameters.AddWithValue("@op", opID);
                            insertCommand.Parameters.AddWithValue("@value", value);
                            insertCommand.Parameters.AddWithValue("@attr", attrID);
                            insertCommand.ExecuteNonQuery();
                        }
                    }
                }
                index++;
            }
        }

        private static void UpdateChampion(SqlConnection conn) { // Outputs: Name, Desc, Slotability, Constellation
            UpdateConstellation(conn, "https://eso-hub.com/en/champion-points/discipline/warfare");
            UpdateConstellation(conn, "https://eso-hub.com/en/champion-points/discipline/fitness");
        }

        private static void UpdateConstellation(SqlConnection conn, string url) {
            HtmlDocument doc = GetDocument(url);

            // Constellation name
            string constName = url.Split('/').Last();
            string constellation = char.ToUpper(constName[0]) + constName.Substring(1);
            string pattern = @"&[^&;]+;";

            var table = doc.DocumentNode.SelectSingleNode("//div[@class='table-responsive'][2]"); // Champion table

            foreach (var row in table.Descendants("tr").Skip(1)) {

                // Link, name, and description
                var link = row.SelectSingleNode("td[@data-label='Name']/a");
                string name = link.InnerText.Trim();
                string desc = row.SelectSingleNode("td[@data-label='Effect']").InnerText;

                // Get DB champion description
                using (SqlCommand command = new SqlCommand("SELECT champ_desc FROM champion WHERE champ_name = @name", conn)) {
                    command.Parameters.AddWithValue("@name", name);
                    string dbDesc = (string) command.ExecuteScalar();

                    if (dbDesc == null) { // Champion not found in DB, so insert it
                        using (SqlCommand insertCommand = new SqlCommand("INSERT INTO champion (champ_name, champ_desc, slottable, constellation)" +
                                                                         "VALUES (@name, @desc, @slot, @const)", conn)) {

                            HtmlDocument cPage = GetDocument(link.Attributes["href"].Value);
                            string slot = cPage.DocumentNode.SelectSingleNode("//strong[text()='Is slotable:']/following-sibling::text()[1]").InnerText.Trim();

                            insertCommand.Parameters.AddWithValue("@name", Regex.Replace(name, pattern, ""));
                            insertCommand.Parameters.AddWithValue("@desc", desc);
                            insertCommand.Parameters.AddWithValue("@slot", slot);
                            insertCommand.Parameters.AddWithValue("@const", constellation);
                            insertCommand.ExecuteNonQuery();
                        }
                    } else if (dbDesc != desc) { // New champion description, so update it
                        using (SqlCommand updateCommand = new SqlCommand("UPDATE champion SET champ_desc = @desc WHERE champ_name = @name", conn)) {
                            updateCommand.Parameters.AddWithValue("@name", name);
                            updateCommand.Parameters.AddWithValue("@desc", desc);
                            updateCommand.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        private static void UpdateMundus(SqlConnection conn) { // Outputs: Name, Desc
            HtmlDocument doc = GetDocument("https://eso-hub.com/en/mundus-stones");

            var table = doc.DocumentNode.SelectSingleNode("//table[@class='table table-hover table-striped']"); // Mundus table

            foreach (var row in table.Descendants("tr").Skip(1)) {
                var mundus = row.SelectNodes("td");

                // Name and description
                string name = mundus[0].InnerText.Trim();
                string html = mundus[1].InnerHtml;
                int index = html.IndexOf("<br>");
                string desc = html.Substring(0, index).Trim();

                // Get DB mundus description
                using (SqlCommand command = new SqlCommand("SELECT mundus_desc FROM mundus WHERE mundus_name = @name", conn)) {
                    command.Parameters.AddWithValue("@name", name);
                    string dbDesc = (string) command.ExecuteScalar();

                    if (dbDesc == null) { // Mundus not found in DB, so insert it
                        using (SqlCommand insertCommand = new SqlCommand("INSERT INTO mundus (mundus_name, mundus_desc) VALUES (@name, @desc)", conn)) {
                            insertCommand.Parameters.AddWithValue("@name", name);
                            insertCommand.Parameters.AddWithValue("@desc", desc);
                            insertCommand.ExecuteNonQuery();
                        }
                    } else if (dbDesc != desc) { // New mundus description, so update it
                        using (SqlCommand updateCommand = new SqlCommand("UPDATE mundus SET mundus_desc = @desc WHERE mundus_name = @name", conn)) {
                            updateCommand.Parameters.AddWithValue("@name", name);
                            updateCommand.Parameters.AddWithValue("@desc", desc);
                            updateCommand.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        private static void UpdateRaces(SqlConnection conn) { // Outputs: Name
            HtmlDocument doc = GetDocument("https://eso-hub.com/en/skills/racial");

            var races = doc.DocumentNode.SelectNodes("//div[@class='card-header text-center']"); // Race table

            foreach (var race in races) {

                // Name
                string str = race.InnerText;
                int index = str.LastIndexOf(' ');
                string name = index == -1 ? str : str.Substring(0, index).Trim();

                string link = race.ParentNode.Attributes["href"].Value;
                Console.WriteLine(link);

                // Get DB race name
                using (SqlCommand command = new SqlCommand("SELECT race_name FROM race WHERE race_name = @name", conn)) {
                    command.Parameters.AddWithValue("@name", name);
                    string dbName = (string) command.ExecuteScalar();

                    if (dbName == null) { // Race not found, so insert it
                        using (SqlCommand insertCommand = new SqlCommand("INSERT INTO race (race_name) VALUES (@name)", conn)) {
                            insertCommand.Parameters.AddWithValue("@name", name);
                            insertCommand.ExecuteNonQuery();
                        }
                    }
                }

                // HtmlDocument page = GetDocument(link);
            }
        }

        private static void UpdateClasses(SqlConnection conn) { // Outputs: Name
            HtmlDocument doc = GetDocument("https://eso-hub.com/en/classes");

            var classes = doc.DocumentNode.SelectSingleNode("//section[@aria-label='Introduction']"); // Class table

            foreach (var clas in classes.Descendants("a")) {
                string name = clas.InnerText;

                // Get DB class name
                using (SqlCommand command = new SqlCommand("SELECT class_name FROM class WHERE class_name = @name", conn)) {
                    command.Parameters.AddWithValue("@name", name);
                    string dbName = (string) command.ExecuteScalar();

                    if (dbName == null) { // Class not found, so insert it
                        using (SqlCommand insertCommand = new SqlCommand("INSERT INTO class (class_name) VALUES (@name)", conn)) {
                            insertCommand.Parameters.AddWithValue("@name", name);
                            insertCommand.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        private static HtmlDocument GetDocument(string url) {
            HttpClient client = new HttpClient(); // Set up the HttpClient

            string html = client.GetStringAsync(url).Result; // Get the HTML from the website

            // Parse the HTML using HtmlAgilityPack
            HtmlDocument doc = new HtmlDocument();
            doc.LoadHtml(html);

            return doc;
        }
    }
}
