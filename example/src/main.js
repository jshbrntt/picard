const process = require("node:process");

function main() {
  console.log(`Hello ${process.env.CI ? "CI" : "world"}!`);
}

if (require.main === module) {
  main();
}

module.exports = { main };
