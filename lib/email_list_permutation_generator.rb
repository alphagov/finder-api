
class EmailListPermutationGenerator
  def initialize(format, choices_hash)
    @format = format
    @choices_hash = choices_hash
  end

  def all_possible_tag_hashes
    each_combination_of(choices_hash["choices"]).map do |combination|
      {"format" => [format], choices_hash["key"] => combination}
    end
  end

private
  attr_reader :format, :choices_hash

  # Creates a powerset for every possible combination of a set of options
  def each_combination_of(value)
    combinations = []
    1.upto(value.size) do |n|
      value.combination(n).each do |combination|
        combinations << combination
      end
    end
    combinations
  end
end
