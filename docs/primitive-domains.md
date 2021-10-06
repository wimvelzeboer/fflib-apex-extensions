# fflib-apex-extensions

## Primitive Domains

A huge benefit of using primitive domains, is that you write less code. 
Instead of:
```apex
List<String> myStrings = getSomeStrings();
```
You can write:

```apex
fflib_Strings myStrings = getSomeString();
```

It is a small thing, but it makes things looks much nicer.


One other benefit is that you can encapsulate more logic as Lists. You can see these lists as a Domain.
Take a look at the SObjects primitive domain, it is the new source for extending domain classes.


### Available Primitive Domains

- Dates
- DateTimes
- Decimals
- Doubles
- Ids
- Integers
- Longs
- [SObjects](domains/sobject.md)
- Strings
