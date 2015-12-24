class AdjacentList

  attr_accessor :start, :end

  def initialize
    @vertices = []
  end

  def add_edge(x, y, label)
    if @vertices[x] == nil
      @vertices[x] = []
      @vertices[x][0] = { label => y }
    else
      last = @vertices[x].length
      @vertices[x][last] = { label => y }
    end
  end

  def to_s
    @vertices.to_s
  end

  def vertices
    vertices = []
    @vertices.each_index do |e|
      vertices << e
    end
    vertices
  end

  def labels(x)
    if @vertices[x] == nil
      return []
    else
      keys = []
      @vertices[x].each do |e|
        e.each_key do |k|
          keys << k
        end
      end
      keys
    end
  end

  def dfs
    @path = []
    @found = false
    dfs_visit(@start)
    @path
  end

  private

  def dfs_visit(vertix)
    @found = true if vertix == @end
    return if @vertices[vertix] == nil || @found

    @vertices[vertix].each do |e|
      e.each_key do |k|
        @path << k
        dfs_visit(e[k])
        @path.pop unless @found
      end
      break if @found
    end
  end
end
