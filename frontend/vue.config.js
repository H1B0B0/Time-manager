module.exports = {
  pwa: {
    name: "ChartManager",
    themeColor: "#4DBA87",
    msTileColor: "#000000",
    appleMobileWebAppCapable: "yes",
    appleMobileWebAppStatusBarStyle: "black",

    manifestOptions: {
      display: "standalone",
      background_color: "#FFFFFF",
    },

    workboxPluginMode: "GenerateSW",
    workboxOptions: {
      navigateFallback: "index.html",
      runtimeCaching: [
        {
          urlPattern: new RegExp("^https://api.example.com/"),
          handler: "networkFirst",
          options: {
            networkTimeoutSeconds: 20,
            cacheName: "api-cache",
            cacheableResponse: {
              statuses: [0, 200],
            },
          },
        },
      ],
    },
  },
};
