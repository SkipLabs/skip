import { createSkdb } from 'skdb';
import chalk from 'chalk';

createSkdb({ asWorker: true }).then(skdb => {
  skdb.schema(
    "CREATE TABLE example (id TEXT PRIMARY KEY, intCol INTEGER NOT NULL, floatCol FLOAT NOT NULL, skdb_access TEXT NOT NULL);",
  ).then(_r => {
    console.log(chalk.green("[OK]") + ' SKDB successfully started in bun.');
    process.exit(0);
  }).catch(err => {
    console.error(err);
    console.log(chalk.red("[FAILED]") + ' Unable to use SKDB in bun.');
    process.exit(2);
  })
}).catch(err => {
  console.error(err);
  console.log(chalk.red("[FAILED]") + ' Unable to load SKDB in bun.');
  process.exit(2);
})