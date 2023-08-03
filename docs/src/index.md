# AIBaltazar.jl

Documentation for AIBaltazar.jl

```@contents
```

## Key Management Functions

```@docs
AIBaltazar.getAPIkey()
```

```@docs
AIBaltazar.setAPIkey(key::String)

AIBaltazar.clearAPIkey()
```

## Conversation Management

```@docs
AIBaltazar.initialize_conversation()

AIBaltazar.save_conversation(filepath)
```

## Output Formatting

```@docs
AIBaltazar.setFormatter(f::Function)

AIBaltazar.markdown(s::String)

AIBaltazar.plaintext(s::String)
```


## Index

```@index
```
