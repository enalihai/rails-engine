class ErrorSerializer
  def self.min_max
    {
    data:
      {
        error: "Invalid Format",
        title: "MIN>MAX => :: min_price cant be greater than max_price!"
      }
    }
  end

  def self.no_match
    {
      data:
      {
        error: nil,
        title: "NOMATCH :: No matching results found in database!"
      }
    }
  end

  def invalid_query
    {
      data:
      {
        error: nil,
        title: "UNKNOWN :: Query params are invalid for search!"
      }
    }, status: 200
  end

  def self.cant_be_blank
    {
      data:
      {
        error: 'Invalid Input',
        title: "BLANK :: Queries params can't be blank!"
      }
    }
  end

  def self.invalid_params
    {
      data:
      {
        error: nil,
        title: "INPUTERROR :: params can't use :name with :min or :max!"
      }
    }
  end
end
