module ColorsHelper
  def singularize_are(num)
    return "are" if num > 1
    return "is" if num == 1
  end
end
