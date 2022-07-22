class ErrorSerializer
  def self.null_result
    { data: 
      {
        error: nil,
        message: 'Unknown Error :: Nil NOMATCH INVALID results!'
      }
    }
  end
end
