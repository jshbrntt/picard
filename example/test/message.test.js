const { main } = require("../src/main.js");

const test = require("node:test");
const assert = require("node:assert");

test("message is correct", (t) => {
  t.mock.method(console, "log");
  main();
  assert.strictEqual(console.log.mock.calls.length, 1);
  const [call] = console.log.mock.calls;
  const [argument] = call.arguments;
  assert.strictEqual(argument, "Hello world!");
});
