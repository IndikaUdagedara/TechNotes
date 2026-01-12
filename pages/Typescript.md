### Run typescript standalone

```ts
async function worker() {
...
}

worker().catch((err) => {
	process.exit(1);
});

```

- Install [tsx](https://www.npmjs.com/package/tsx)
- Run `tsx worker.ts` or `tsx --watch worker.ts`
- ## tsconfig
  - `compilerOptions`
    - `target` - which JS language specification should TS be transpiled into
    - `module` and `moduleResolution` go hand in hand
      - `module` - which module specification to be used e.g., ES Modules
        (`import` and `export`) or CommonJS Modules (`require` and
        `module.exports`)
      - `moduleResolution` - how module names to be resolved
        - if `moduleResolution: bundler` then module names shouldn't have
          extension `import * from 'pkg'` where a bundler like `tsx` or
          `webpack` will be resolving modules
          [moduleResolution docs](https://www.typescriptlang.org/docs/handbook/modules/reference.html#the-moduleresolution-compiler-option)
- ## ORM
  - Drizzle
    - query vs select
      - query is to query a single table
      - select can do joins
