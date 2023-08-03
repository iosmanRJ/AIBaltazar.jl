const api_model_name = "OPENAI_MODEL"
const api_pref_model_name = "openai_model"

"""
    function getModelName()

Returns an OpenAI model name to use from either the `LocalPreferences.toml` file or the
`OPENAI_MODEL` environment variable. If neither is present, returns `missing`.
"""
function getModelName()
    model_name = missing

    # try to load key from Preferences:
    model_name = @load_preference(api_pref_model_name, missing)

    # if not koaded from preferences, look in environment variables
    if ismissing(model_name) && haskey(ENV, api_model_name)
        model_name = ENV[api_model_name]
    end

    return model_name
end

"""
    function setModelName(key::String)

Sets the OpenAI Model name for AIBaltazar to use. The name will be saved as plaintext to your environment's
`LocalPreferences.toml` file (perhaps somewhere like `~/.julia/environments/v1.8/LocalPreferences.toml`).
The model name can be deleted with `AIBaltazar.clearModelName()`. 
"""
function setModelName(model_name::String)
    @set_preferences!(api_pref_model_name => model_name)
end

"""
    function clearAPIkey()

Deletes the OpenAI API key saved in `LocalPreferences.toml` if present. 

See also: AIBaltazar.setAPIkey(key::String)
"""
function clearModelName()
    @delete_preferences!(api_pref_model_name)
end
