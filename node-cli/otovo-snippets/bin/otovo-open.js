#!/usr/bin/env node
const qs = require("querystring");
const open = require("open");

const types = {
  interests: ["i"],
  projects: ["p"],
  "cost-models": ["cm"],
  staff: ["s"],
  installers: ["inst"],
  contracts: ["c"],
};

const typesArr = Object.keys(types);
const typesWithAliases = typesArr.flatMap((type) => [type, ...types[type]]);

const options = require("yargs/yargs")(process.argv.slice(2))
  .usage(`Usage: $0 <${typesArr.toString()}> [filters]`)
  .demandCommand(0, 1, "Select data type to query")
  .check((argv) => {
    const { _ } = argv;
    const type = _[0] || "interests"; // default to interest
    if (typesWithAliases.includes(type)) {
      return true;
    }
    throw new Error(`Invalid option. Should be one of <${typesWithAliases}>`);
  })
  .option("staging", {
    describe: "Use staging environment.",
    type: "boolean",
  })
  .option("browser", {
    alias: "b",
    describe: "Open URL in browser",
    type: "boolean",
  })
  .option("market", {
    alias: "m",
    describe: "Filter on market.",
    default: "",
    type: "string",
  })
  .option("query", {
    alias: "q",
    describe: "Add a free-text query string.",
    default: "",
    type: "string",
  })
  .option("status", {
    alias: "s",
    describe: "Filter on status.",
    default: "",
    type: "string",
  }).argv;

function resolveType(type) {
  switch (type) {
    case "inst":
      return "installers";
    case "i":
      return "interests";
    case "projects":
    case "p":
      return "planning/projects";
    case "cost-models":
    case "cm":
      return "platform/cost-models";
    default:
      return type;
  }
}

async function main() {
  const { staging, status, _: type, market, browser, query } = options;
  const baseURL = `https://${staging ? "staging-" : ""}cloud.otovo.com/`;
  const _type = resolveType(type[0]);
  const queryString = {
    ...(status ? { status: status } : {}),
    ...(market ? { country: market } : {}),
    ...(query ? { query: query } : {}),
  };
  const finalURL = `${baseURL}${_type}/?${qs.stringify(queryString)}`;
  if (browser) {
    console.log("Opening URL in Browser...");
    await open(finalURL);
    return console.log(`Done: ${finalURL}`);
  }

  console.log(finalURL);
}

main();
