RSpec::Matchers.define :be_monotonically_increasing do
  match do |actual|
    derivative = actual.each_cons(2).map { |x, y| y <=> x }
    derivative.all? { |v| v >= 0 }
  end

  failure_message do |actual|
    "expected array #{actual.inspect} to be monotonically increasing"
  end
  
  failure_message_when_negated do |actual|
    "expected array #{actual.inspect} to not be monotonically increasing"
  end

  description do
    'be monotonically increasing'
  end
end
