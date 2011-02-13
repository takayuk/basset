#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require"bigdecimal"

def rand_normal avg,var
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

def rand_gamma alpha,beta
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
      @z=rand_normal(0.0,1.0)
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

def rand_dirichlet alpha
  @k=alpha.size.freeze

  @y=Array.new(@k)
  for i in 0..(@k-1)
    @y[i]=BigDecimal::new(rand_gamma(alpha[i],1.0).to_s)
  end

  @ytotal = @y.inject(0){|sum,i|sum+i}.to_f.freeze

  @x=Array.new(@k)
  for i in 0..(@k-1)
    @x[i]=@y[i]/@ytotal
  end
  @x
end

