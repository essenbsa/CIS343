#
#  Class that represents a Matrix and implements operations on matrices.
#
#  Author(s): Sam Essenburg, Isaac Smith
#
class Matrix
  # create getter methods for instance variables @rows and @columns
  attr_reader  :rows, :columns

  # create setter methods for instance variables @rows and @columns
  attr_writer  :rows, :columns

  # make setter methods for @rows and @columns private
  private :rows=, :columns=
  
  # method that initializes a newly allocated Matrix object
  # use instance variable named @data (an array) to hold matrix elements
  # raise ArgumentError exception if any of the following is true:
  #     parameters rows or columns or val is not of type Fixnum
  #     value of rows or columns is <= 0
  def initialize(rows=5, columns=5, val=0)
	raise ArgumentError, 'Invalid Types' unless (rows.is_a? Fixnum) and (columns.is_a? Fixnum)
	raise ArgumentError, 'Invalid Input' unless rows > 0 && columns > 0
	@rows = rows
	@columns = columns
	@val = val
	@data = []#Array.new(columns){Array.new(rows)}
	for r in 0...rows
	  for c in 0...columns
	    @data.push val
	  end
	end
  end

  # method that returns matrix element at location (i,j)
  # NOTE: row and column values are zero-index based
  # raise ArgumentError exception if any of the following is true:
  #     parameters i or j is not of type Fixnum
  #     value of i or j is outside the bounds of Matrix
  def get(i, j)
	raise ArgumentError, 'Invalid Types' unless i.is_a? Fixnum and j.is_a? Fixnum
	raise ArgumentError, 'Out of bounds' unless (i.between?(0, @rows-1)) and (j.between?(0, @columns-1))
	@data[i*@columns + j]	
  end

  # method to set the value of matrix element at location (i,j) to value of parameter val
  # NOTE: row and column values are zero-index based
  # raise ArgumentError exception if any of the following is true:
  #     parameters i or j or val is not of type Fixnum
  #     the value of i or j is outside the bounds of Matrix
  def set(i, j, val)
	raise ArgumentError, 'Invalid Types' unless rows.is_a? Fixnum and columns.is_a? Fixnum
	raise ArgumentError, 'Out of bounds' unless i.between?(0, @rows-1) && j.between?(0, @columns-1)

	@data[i*@columns + j] = val
  end

  # method that returns a new matrix object that is the sum of this and parameter matrices.
  # raise ArgumentError exception if the parameter m is not of type Matrix
  # raise IncompatibleMatricesError exception if the matrices are not compatible for addition operation
  def add(m)
	raise ArgumentError, 'Invalid Type' unless m.is_a? Matrix
	raise IncompatibleMatricesError, 'Incompatible Matricies' unless m.rows == @rows && m.columns == @columns
	mat = Matrix.new(@rows, @columns, 0)
	
	for r in 0...@rows
	  for c in 0...@columns
	    mat.set(r, c, self.get(r, c) + m.get(r, c))
	  end
	end

	return mat
  end

  # method that returns a new matrix object that is the difference of this and parameter matrices
  # raise ArgumentError exception if the parameter m is not of type Matrix
  # raise IncompatibleMatricesError exception if the matrices are not compatible for subtraction operation
  def subtract(m)

	raise ArgumentError, 'Invalid Type' unless m.is_a? Matrix
	raise IncompatibleMatricesError, 'Incompatible Matricies' unless (m.rows == @rows) && (m.columns == @columns)
	mat = Matrix.new(@rows, @columns, 0)
	
	for r in 0...@rows
	  for c in 0...@columns
	    mat.set(r, c, self.get(r, c) - m.get(r, c))
	  end
	end
	return mat
  end

  # method that returns a new matrix object that is a scalar multiple of source matrix object
  # raise ArgumentError exception if the parameter k is not of type Fixnum
  def scalarmult(k)
	raise ArgumentError, 'Invalid Type' unless k.is_a? Fixnum
	
	mat = Matrix.new(@rows, @columns, 0)
	
	for r in 0...@rows
	  for c in 0...@columns
	    mat.set(r, c, self.get(r, c) * k) 
	  end
	end

	return mat
  end

  # method that returns a new matrix object that is the product of this and parameter matrices
  # raise ArgumentError exception if the parameter m is not of type Matrix
  # raise IncompatibleMatricesError exception if the matrices are not compatible for multiplication operation
  def multiply(m)
	raise ArgumentError, 'Invalid Type' unless m.is_a? Matrix
	raise IncompatibleMatricesError, 'Incompatible Matricies' unless m.rows == @columns

	mat = Matrix.new(@rows, m.columns, 0)
	for r in 0...@rows
	  for c in 0...m.columns
	    for col in 0...@columns
	      temp = mat.get(r, c)
	      temp += (self.get(r, col) * m.get(col, c))
	      mat.set(r, c, temp)
	    end
	  end
	end
	return mat
  end

  # method that returns a new matrix object that is the transpose of the source matrix
  def transpose
	mat = Matrix.new(@columns, @rows, 0)
	for c in 0...@columns
	  for r in 0...@rows
	    mat.set(c, r , self.get(r, c))
	  end
	end
	return mat
  end

  # overload + for matrix addition
  def +(m)
    add(m)
  end

  # overload - for matrix subtraction
  def -(m)
    subtract(m)
  end

  # overload * for matrix multiplication
  def *(m)
    multiply(m)
  end

  # class method that returns an identity matrix with size number of rows and columns
  # raise ArgumentError exception if any of the following is true:
  #     parameter size is not of type Fixnum
  #     the value of size <= 0
  def Matrix.identity(size)
	raise ArgumentError, 'Invalid Type' unless size.is_a? Fixnum
	raise ArgumentError, 'Invalid Number' unless size > 0

	mat = Matrix.new(size, size, 0)
	for r in 0...size
	  for c in 0...size
	    if r == c
	      mat.set(r,c,1)
	    end
	  end
	end
	return mat
  end

  # method that sets every element in the matrix to value of parameter val
  # raise ArgumentError exception if val is not of type Fixnum
  # hint: use fill() method of Array to fill the matrix
  def fill(val)
	raise ArgumentError, 'Invalid Type' unless val.is_a? Fixnum
	@data.fill(val)
  end

  # method that return a deep copy/clone of this matrix object
  def clone
	mat = Matrix.new(@rows, @columns, 0)
	for r in 0...@rows
	  for c in 0...@columns
	    mat.set(r, c, self.get(r, c))
	  end
	end
	return mat
  end

  # method that returns true if this matrix object and the parameter matrix object are equal
  # (i.e., have the same number of rows, columns, and corresponding values in the two
  # matrices are equal). Otherwise, it returns false.
  # returns false if the parameter m is not of type Matrix
  def ==(m)
	return false unless m.is_a? Matrix and @rows == m.rows and @columns == m.columns
	for r in 0...@rows
	  for c in 0...@columns
	    if m.get(r, c) != self.get(r, c)
	      return false
	    end
	  end
	end
	return true	
  end

  # method that returns a string representation of matrix data in table (row x col) format
  def to_s
	str = ""
	for r in 0...@rows
	  for c in 0...@columns
	    str += "#{self.get(r, c)} "
	  end
	  str = str[0..-2]
	  str += "\n"
	end
	return str
  end

  # method that for each element in the matrix yields with information
  # on row, column, and data value at location (i,j)
  def each
	for r in 0...@rows
	  for c in 0...@columns
	    yield r, c, self.get(r, c)
	  end
	end	
  
  end
end
#
# Custom exception class IncompatibleMatricesError
#
class IncompatibleMatricesError < Exception
  def initialize(msg)
    super msg
  end
end

#
#  main test driver
#
def main
  m1 = Matrix.new(3,4,10)
  m2 = Matrix.new(3,4,20)
  m3 = Matrix.new(4,5,30)
  m4 = Matrix.new(3,5,40)

  puts(m1)
  puts(m2)
  puts(m3)
  puts(m4)

  puts(m1.add(m2))

  puts(m1.subtract(m2))

  puts(m1.multiply(m3))

  puts(m2.scalarmult(5))

  puts(Matrix.identity(5))

  puts(m1 + m2)

  puts(m2 - m1)

  puts(m1 * m3)

  puts(m1 + m2 - m1)

  puts(m4 + m2 * m3)

  puts(m1.clone())

  puts(m1.transpose())

  puts("Are matrices equal? #{m1 == m2}")

  puts("Are matrices equal? #{m1 == m3}")

  puts("Are matrices equal? #{m1 == m1}")

  m1.each { |i, j, val|
    puts("(#{i},#{j},#{val})")
  }

  begin
    m1.get(4,4)
  rescue ArgumentError => exp
    puts("#{exp.message} - get failed\n")
  end

  begin
    m1.set(4,5,10)
  rescue ArgumentError => exp
    puts("#{exp.message} - set failed\n")
  end

  begin
    m1.add(m3)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - add failed\n")
  end

  begin
    m2.subtract(m3)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - subtract failed\n")
  end

  begin
    m1.multiply(m2)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - multiply failed\n")
  end

  begin
    m1 + m3
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - add failed\n")
  end

  begin
    m2 - m3
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - subtract failed\n")
  end

  begin
    m1 * m2
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - multiply failed\n")
  end

end

# uncomment the following line to run the main() method
 main()
