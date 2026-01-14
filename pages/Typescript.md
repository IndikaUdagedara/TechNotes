# TypeScript

## Run TypeScript Standalone

```ts
async function worker() {
  // ...
}

worker().catch((err) => {
  process.exit(1);
});
```

### Setup

1. Install [tsx](https://www.npmjs.com/package/tsx)
2. Run `tsx worker.ts` or `tsx --watch worker.ts`

## tsconfig

### compilerOptions

**target**
- Which JS language specification TypeScript should be transpiled into

**module and moduleResolution**

These two options go hand in hand:

- `module` - Which module specification to use (e.g., ES Modules with `import`/`export` or CommonJS with `require`/`module.exports`)
- `moduleResolution` - How module names are resolved
  - If `moduleResolution: bundler`, then module names shouldn't have an extension:
    ```ts
    import * from 'pkg'  // bundler like tsx or webpack will resolve modules
    ```
  - See [moduleResolution docs](https://www.typescriptlang.org/docs/handbook/modules/reference.html#the-moduleresolution-compiler-option)

## ORMs

### Drizzle

**query vs select**
- `query` - Query a single table
- `select` - Can perform joins
