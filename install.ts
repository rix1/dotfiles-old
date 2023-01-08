import { Table } from "https://deno.land/x/cliffy@v0.25.6/table/mod.ts";

import {
  Confirm,
  Input,
} from "https://deno.land/x/cliffy@v0.25.7/prompt/mod.ts";
import { humanize } from "./utils/humanize.ts";
import { error, info } from "./utils/prompt.ts";
import { installFonts } from "./installScripts/fonts.ts";
import { setupMac } from "./installScripts/macos.ts";

let email: string, name: string;

// await initialize();
// await promptSudo();

// await installBrew();
// await installBrewApps("./requirements/brew.txt");
// await installBrewApps("./requirements/cask.txt");
// await installFonts();
// await setupMac();

// symlinks
// git config
// fish, fisher and startship

async function initialize() {
  email = await Input.prompt({
    message: "Enter your email",
    default: email ?? "rikardeide@gmail.com",
  });

  name = await Input.prompt({
    message: "Enter your name",
    default: name ?? "Rikard Eide",
  });

  console.log({ email, name });
  if (!(await Confirm.prompt("Is everything correct?"))) {
    await initialize();
  }

  console.log(info("\nAll set! Here's what will happen next"));

  const tableOfContents: Table<[string, number]> = Table.from([
    ["Set MacOS defaults", 10],
    ["Install brew", 60 * 2],
    ["Install command line software (Brew)", 60 * 5],
    ["Install useful software (Brew cask)", 60 * 4],
    ["Configure Fish shell and Starship prompt", 60 * 2],
    ["Install Fish plugins (Fisher)", 60],
    ["Install fonts", 10],
    ["Symlink other configuration files", 10],
  ]);

  const sum = tableOfContents
    .map((el) => el[1])
    .reduce((sum, next) => sum + next, 0);
  tableOfContents.push(["Total ETA", sum]);
  const formatted = tableOfContents
    .map((el, index) => [
      index === tableOfContents.length - 1 ? "\ue0b0" : index + 1,
      el[0],
      humanize(el[1]),
    ])
    .toString();

  console.log(formatted);

  if (!(await Confirm.prompt("Ready to roll?"))) {
    console.log(info("Exiting..."));

    Deno.exit(0);
  }
  console.log(error("Not implemented yet!"));
}
