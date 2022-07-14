class ErrorSerializer
  def self.invalid_parameters
    {
    data:
      {
        id: 'error',
        title: 'Invalid input'
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
end
