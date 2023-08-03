using Documenter
using AIBaltazar

makedocs(sitename = "AIBaltazar", format = Documenter.HTML(), modules = [AIBaltazar])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(repo = "github.com/ThatcherC/AIBaltazar.jl.git")
