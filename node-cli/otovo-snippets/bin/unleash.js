const { Unleash, getFeatureToggleDefinitions } = require("unleash-client");

const UNLEASH_API_URL_STAGING = "https://staging-feature-toggles.otovo.com/api";
const UNLEASH_API_URL_PRODUCTION = "https://feature-toggles.otovo.com/api";

const unleash = new Unleash({
  appName: "otovowe",
  url: UNLEASH_API_URL_STAGING,
});

// const {
//   initialize,
//   getFeatureToggleDefinition,
//   getFeatureToggleDefinitions,
// } = require("unleash-client");

// initialize({
//   url: UNLEASH_API_URL_STAGING,
//   appName: "otovoweb",
//   // instanceId: "my-unique-instance-id",
// });

// const featureToogleX = getFeatureToggleDefinition("app.ToggleX");
unleash.on("ready", (data) => {
  console.log(datas);
  const featureToggles = getFeatureToggleDefinitions();

  console.log(featureToggles);
});
