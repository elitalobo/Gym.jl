function install_envs()
  cd("gym")
  if haskey(ENV, "GYM_ENVS")
    envs = split(ENV["GYM_ENVS"], ":")
    for env in envs
      println(env)
      run(`pip install --user -e .[$env]`)
      @info("$env environment has been installed")
      println("done")
    end
  else
    println("building minimial")
    run(`pip install --user -e .`)
    @info("Minimal installation has been performed")
    @info("To install everything, set ENV[\"GYM_ENVS\"]=all")
    @info("Then build the package again, Pkg.build(\"Gym\")")
  end
  cd("..")
end

function which_gym()
  whichgym = ""
  filename = "whichgym"
  if isfile(filename)
    f = open(whichgym)
    whichgym = strip(readstring(f))
    close(f)
  else
    whichgym = "SYSTEM"
  end
  return whichgym
end

try
  using PyCall
  PyCall.pyimport("gym")
  if which_gym() == "SYSTEM"
    @warn("You are using the gym from the systemwise installation.")
    @warn("If you want to install new environments, you should install them using \"pip install -e .[env]\"")
  else
    install_envs()
  end
catch
  if !isdir("gym")
    @info("Downloading OpenAi gym")
    #run(`git clone https://github.com/openai/gym.git`)
    run(`pip install gym==0.12.1`)
    println("Downloading gym=0.12.1")
  end
  @info("Installing OpenAi gym")
  #install_envs()
  filename = "whichgym"
  f = open(filename, "w")
  write(f, "OWN")
  close(f)
end
