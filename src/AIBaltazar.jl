module AIBaltazar

import OpenAI
import ReplMaker
import Markdown

using Preferences

include("formatting.jl")
include("keys.jl")
include("models.jl")

"""
    function AIBaltazar.generate_empty_conversation()

Returns a new empty conversation history.
"""
function generate_empty_conversation()
    Vector{Dict{String,String}}()
end

conversation = generate_empty_conversation()

"""
    function AIBaltazar.initialize_conversation()

Sets the Baltazar conversation to an empty state. This effectively
starts a new chat with Baltazar with no recollection of past messages.
"""
function initialize_conversation()
    global conversation = generate_empty_conversation()
end

"""
    function AIBaltazar.conversation_as_string()

Serializes a conversation history to a string. Messages sent from the user
are preceded by "You:", messages from Baltazar are preceded by "Baltazar:",
and any system messages are preceded by "System:".

"""
function conversation_as_string()
    buf = IOBuffer()
    for message in conversation
        if message["role"] == "user"
            println(buf, "You:")
            println(buf, "----\n")
        elseif message["role"] == "assistant"
            println(buf, "Baltazar:")
            println(buf, "--------\n")
        elseif message["role"] == "system"
            println(buf, "System:")
            println(buf, "-------\n")
        end

        println(buf, message["content"])
        println(buf)
    end

    String(take!(buf))
end

"""
    function AIBaltazar.save_conversation(filepath)

Saves the output of [`AIBaltazar.conversation_as_string()`](@ref) to a file at 
`filepath`. See the chat and output of AIBaltazar.save_conversation() below.

## Example:

```julia
julia> 

Baltazar> What does LISP stand for in computing?
  LISP stands for "LISt Processor".

Baltazar> How about FORTRAN?
  FORTRAN stands for "FORmula TRANslation".

julia> AIBaltazar.save_conversation("/tmp/convo.txt")

shell> cat /tmp/convo.txt
You:
----

What does LISP stand for in computing?

Baltazar:
--------

LISP stands for "LISt Processor".

You:
----

How about FORTRAN?

Baltazar:
--------

FORTRAN stands for "FORmula TRANslation".
```
"""
function save_conversation(filepath)
    s = conversation_as_string()

    try
        open(filepath, "w") do io
            println(io, s)
        end
    catch
        @error "Failed to open file '$filepath'!"
    end
end

function call_Baltazar(s)
    key = getAPIkey()
    model = getModelName()
    if !ismissing(key)

        if ismissing(model)
            model = "gpt-3.5-turbo"
            setModelName(model)
            @warn format(
                "OpenAI model not defined. Setting gpt-3.5-turbo as a default model. Please change it with `AIBaltazar.setModelName(\"<YOUR PREFERED OPENAI MODEL>\")` or set the environment variable $(api_model_name)=<YOUR PREFERED OPENAI MODEL>",
            )
        end

        userMessage = Dict("role" => "user", "content" => s)
        push!(conversation, userMessage)

        # gpt-3.5-turbo
        r = OpenAI.create_chat(key, model, conversation)

        # TODO: check for errors!
        #if !=(r.status, 200)
        #  @test false
        #end  
        response = r.response["choices"][begin]["message"]["content"]

        # append Baltazar's response to the conversation history
        # TODO: the object built here might just be the same as r.response["choices"][begin]["message"]
        responseMessage = Dict("role" => "assistant", "content" => response)
        push!(conversation, responseMessage)

        format(response)
    else
        format(
            "OpenAI API key not found! Please set with `AIBaltazar.setAPIkey(\"<YOUR OPENAI API KEY>\")` or set the environment variable $(api_key_name)=<YOUR OPENAI API KEY>",
        )
    end
end

function init_repl()

    if ismissing(getAPIkey())
        @warn "OpenAI API key not found! Please set with `AIBaltazar.setAPIkey(\"<YOUR OPENAI API KEY>\")` or set the environment variable $(api_key_name)=<YOUR OPENAI API KEY>"
    end

    if ismissing(getModelName())
        @warn "OpenAI model not defined! Please set it with `AIBaltazar.setModelName(\"<YOUR PREFERED OPENAI MODEL>\")` or set the environment variable $(api_model_name)=<YOUR PREFERED OPENAI MODEL>"
    end

    ReplMaker.initrepl(
        call_Baltazar,
        prompt_text = "Baltazar> ",
        prompt_color = :blue,
        start_key = '}',
        mode_name = "Baltazar_mode",
    )
end

__init__() = isdefined(Base, :active_repl) ? init_repl() : nothing


end # module
