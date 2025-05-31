import eslintPluginJest from 'eslint-plugin-jest';

/** @type {import("eslint").Linter.FlatConfig} */
export default [
  {
    files: ['**/*.js'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        // Soporte para Node.js
        process: 'readonly',
        __dirname: 'readonly',
        console: 'readonly',

        // Soporte para Jest
        describe: 'readonly',
        test: 'readonly',
        expect: 'readonly',
        jest: 'readonly',
        beforeEach: 'readonly',
        afterEach: 'readonly',
        afterAll: 'readonly'
      }
    },
    plugins: {
      jest: eslintPluginJest
    },
    rules: {
      // Reglas base o personalizadas
      'no-undef': 'error'
    }
  }
];
