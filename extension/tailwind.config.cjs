const config = {
  content: ['./src/**/*.{html,js,svelte,ts}', './node_modules/flowbite-svelte/**/*.{html,js,svelte,ts}'],

  plugins: [require('flowbite/plugin')],

  darkMode: 'class',

  theme: {
    fontFamily: {
      pre: ['system-ui', 'Hiragino Kaku Gothic ProN', 'sans-serif'],
    },
    extend: {
      fontSize: {
        xs: ['0.65rem', '0.65rem'],
        sm: ['0.7rem', '0.7rem'],
      },
      colors: {
        primary: {
          '50': '#f3f7fc',
          '100': '#e6eff8',
          '200': '#c7ddf0',
          '300': '#95c1e4',
          '400': '#5da2d3',
          '500': '#3886bf',
          '600': '#286ba1',
          '700': '#215583',
          '800': '#1f496d',
          '900': '#1f3e5b',
          '950': '#172d44',
        },
      },
    },
  },
};

module.exports = config;
