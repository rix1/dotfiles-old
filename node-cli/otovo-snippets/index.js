const pkg = require("./package.json");
const commandsList = Object.keys(pkg.bin).reduce(
  (prev, next) => `${prev}\n- ${next} (see -> ${pkg.bin[next]})`,
  ""
);
console.log(`Welcome to ${pkg.name}: ${pkg.description}.`);
console.log(`Available commands: ${commandsList}`);
