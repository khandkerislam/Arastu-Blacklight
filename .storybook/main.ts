import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  stories: ["../app/javascript/stories/**/*.stories.@(js|jsx|ts|tsx)"],
  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@storybook/addon-interactions",
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
  docs: {
    autodocs: "tag",
  },
  // Important for Docker setup
  core: {
    disableTelemetry: true,
  },
  // Configure Vite for Docker
  viteFinal: async (config) => {
    return {
      ...config,
      server: {
        ...config.server,
        host: true,
        port: 6006,
        watch: {
          usePolling: true,
        },
      },
    };
  },
};

export default config;