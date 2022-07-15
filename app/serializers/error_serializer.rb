class ErrorSerializer
  def self.invalid_parameters
    {
    data:
      {
        id: 'error',
        title: 'Invalid input: Formatting error'
      }
    }
  end

  def self.no_results_found
    {
    data:
      {
        id: 'error',
        title: "No results found for user input"
      }
    }
  end

  def self.cant_be_blank
    {
    data:
      {
        id: 'error',
        title: 'Invalid input: Search cant be blank'
      }
    }
  end

  def self.nil_query
    {
    data:
      {
        id: 'error',
        title: 'Invalid input: nil query bad'
      }
    }
  end

  def self.min_greater_than_max
    {
    data:
      {
        id: 'error',
        title: 'Invalid input: min price must be < max price'
      }
    }
  end
end
