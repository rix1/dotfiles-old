#!/usr/bin/env node

const markets = {
  no: "Norway",
  se: "Sweden",
  pl: "Poland",
  fr: "France",
  it: "Italy",
  es: "Spain",
};

const marketKeys = Object.keys(markets);

const urlRegex = new RegExp(
  "(.+[.,/])([" + marketKeys.toString() + "]{2})([/,:].+)"
);

const options = require("yargs/yargs")(process.argv.slice(2))
  .usage("Usage: $0 [URL] [options]")
  .demandCommand(1, 1, "Please add an URL")
  .check((argv) => {
    const { _ } = argv;
    const url = _[0];
    const match = url.match(urlRegex);
    if (match && marketKeys.includes(match[2])) {
      return true;
    }
    throw new Error(
      `Not a valid market URL. URL must contain either <${marketKeys.toString()}>`
    );
  })
  .option("format", {
    alias: "f",
    describe: "Apply specific formatting to the output.",
    default: "",
    choices: ["md", "raw", "todo", ""],
    type: "string",
  }).argv;

function main() {
  const { _, format } = options;
  const url = _[0];
  Object.keys(markets).forEach((key) => {
    const market = markets[key];
    const newUrl = url.replace(urlRegex, `$1${key}$3`);
    switch (format) {
      case "md":
        return console.log(`[${market}](${newUrl})`);
      case "todo":
        return console.log(`- [ ] [${market}](${newUrl})`);
      case "raw":
        return console.log(newUrl);
      default:
        return console.log(market, newUrl);
    }
  });
}

main();
