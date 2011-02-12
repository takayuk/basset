#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

def prob_normal avg,var
  @a=Math::sqrt(Math::log(4.0)).freeze
  @b=Math::sqrt(2.0*Math::PI).freeze
  @s=(@a/(@b-@a)).freeze
  @p=((@s+1.0)/2.0).freeze
  @q=Math::log(@s).freeze
  
  @u1=rand
  @u1_=2.0*@u1

  @sign=nil
  @ux=nil
  if @u1_ > 1.0
    @sign=-1
    @ux=@b*(@u1_-1.0)
  else
    @sign=1
    @ux=@b*@u1_
  end
 
  @y=nil
  if @ux < @a
    @y=@sign*@ux
  else
    @u2=rand
    @u2_=@u2 / 2.0
    
    if Math::log(@u2_) < -((@ux**2)/2.0)
      @y=@sign*@ux
    else
      @y=@sign*@s*(@b-@ux)
      unless Math::log(@p-@u2_) < (@q - ((@y**2)/2.0))
        loop do
          @x=rand*2.0*@b
          if @x > @b
            @y=@x*@sign
            break
          end
        end
      end
    end
  end
 
  (avg + (var * @y))
end

def prob_gamma alpha,beta
  @d=(alpha.to_f - (1.0/3.0)).freeze
  begin
    @c=(1.0 / Math::sqrt(9.0 * @d)).freeze
  rescue
    p @d,alpha,beta
    exit
  end
  
  @x=nil
  loop do
    @v=0.0
    @z=nil
    while @v <= 0.0
      @z=prob_normal(0.0,1.0)
      @v=(1.0 + (@c*@z))
    end

    @w=@v**3
    @y=@d*@w
    @u=rand
    
    unless @u <= (1.0 - (0.0331 * (@z**4)))
      if (((@z**2)/2.0) + (@d*Math::log(@w)) - @y + @d) < Math::log(@u)
        redo
      end
    end
    @x=beta*@y
    break
  end
  @x
end

def prob_dirichlet alpha
  @k=alpha.size.freeze

  @y=0.0
  @y_i=Array.new(@k)
  for i in 0..(@k-1)
    @y_i[i]=prob_gamma(alpha[i],1.0)
    @y+=@y_i[i]
  end
  p @y_i,@y
  @y.freeze

  @x_i=Array.new(@k)
  for i in 0..(@k-1)
    @x_i[i]=(@y_i[i]/@y)
  end
  @x_i
end


round = Proc.new{|n,d|(n*10**d).round / 10.0**d}

#@h=Hash.new(0)
open("dirichlet.txt","w"){|f|
  10.times do 
    #@h[round.call(prob_normal(0.0, 1.0), 2)]+=1
    #@h[round.call(prob_gamma(0.4,1.0),2)]+=1
    #@h[round.call(prob_gamma(2.0,1.0),2)]+=1
    #@h[round.call(prob_gamma(4.0,1.0),2)]+=1
    p @d=prob_dirichlet([5.0,5.0,2.0])
    #f.puts "#{round.call(@d[0],2)},#{round.call(@d[1],2)},#{round.call(1.0-@d[0]-@d[1],2)}"
    f.puts "#{round.call(@d[0],2)},#{round.call(@d[1],2)},#{round.call(@d[2],2)}"
  end
}
=begin
open("gamma.csv","w"){|f|
  @h.each{|k,v| f.puts "#{k},#{v}"}
}
=end
