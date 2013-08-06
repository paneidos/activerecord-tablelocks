def list_of_random_numbers(count)
  Kernel.srand RSpec.configuration.seed
  result = count.times.map { Kernel.rand }
  Kernel.srand # reset random generation
  result
end
