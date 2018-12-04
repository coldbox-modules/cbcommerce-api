# normalizer

## Normalize variable values to lists and arrays

This module exposes a simple function that can be injected using WireBox.

```cfc
wirebox.getInstance( "normalizeToArray" );
```

`normalizeToArray` can take a simple value, a list, a query, a struct, an array, or even variadic parameters and return an array of those values.