class CovidTestDecorator < SimpleDelegator
  def formatted_date
    date.strftime('%d/%m/%Y')
  end

  def result_description
    result ? 'Positivo' : 'Negativo'
  end
end