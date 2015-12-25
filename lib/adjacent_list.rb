class AdjacentList
  attr_accessor :start

  def initialize
    @vertices = []
  end

  def add_edge(x, y, label)
    if @vertices[x].nil?
      @vertices[x] = []
      @vertices[x][0] = { label => y }
    else
      last = @vertices[x].length
      @vertices[x][last] = { label => y }
    end
  end

  def +(other)
    start_idx = last + 1
    other.vertices.each_index do |i|
      next if other.vertices[i].nil?
      other.vertices[i].select! do |e|
        e.each_key { |k| e[k] = e[k] + start_idx }
      end
      @vertices[start_idx + i] = other.vertices[i]
    end
    @vertices
  end

  def labels(x)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect { |e| e.keys.first }
    end
  end

  def neigbours(x)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect { |e| e.values.first }
    end
  end

  def neigbour(x, label)
    if @vertices[x].nil?
      return []
    else
      neigbours = @vertices[x].select { |e| e.key?(label) }
      neigbours.collect { |e| e.values.first }
    end
  end

  def set_neigbour(x, label, y)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect! do |e|
        e[label] = y if e.key?(label)
        e
      end
    end
  end

  def dfs
    @path = []
    @string = 'aca'
    dfs_visit(@start)
    @path
  end

  def matches(string)
    @string = string
    dfs
    if @found
      true
    else
      false
    end
  end

  def last
    all_vertices = (0..@vertices.length).collect { |e| neigbours(e) }
    all_vertices.flatten!.sort!.last
  end

  def to_s
    @vertices.to_s
  end

  protected

  attr_reader :vertices

  private

  def dfs_visit(vertix)
    @found = true if final?(vertix) && @string.include?(@path.join)
    return if @vertices[vertix].nil? || @found

    labels(vertix).each do |e|
      @path << e unless e == :empty
      neigbours = neigbour(vertix, e)
      neigbours.each { |n| dfs_visit(n) }

      if @found
        break
      else
        @path.pop unless e == :empty
      end
    end
  end

  def final?(vertix)
    final_states = (0..last).select { |e| @vertices.at(e).nil? }
    final_states.include?(vertix)
  end
end
