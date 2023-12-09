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
        xs: ['0.67rem', '0.67rem'],
        sm: ['0.7rem', '0.7rem'],
      },
      colors: {
        primary: {
          '50': '#f3f7fc',
          '100': '#e7eff7',
          '200': '#c9dcee',
          '300': '#99bfe0',
          '400': '#629ece',
          '500': '#3e82b9',
          '600': '#2d679c',
          '700': '#285886',
          '800': '#234869',
          '900': '#223d58',
          '950': '#16273b',
        },
      },
    },
  },
};

module.exports = config;
