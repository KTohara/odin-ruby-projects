# frozen_string_literal: true

# Monkey-patched String class for colors
class String
  def black
    "\e[2m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def pink
    "\e[91m#{self}\e[0m"
  end

  def green
    "\e[92m#{self}\e[0m"
  end

  def yellow
    "\e[93m#{self}\e[0m"
  end

  def blue
    "\e[94m#{self}\e[0m"
  end

  def purple
    "\e[95m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end

  def bg_red
    "\e[41m#{self}\e[0m"
  end

  def bg_green
    "\e[42m#{self}\e[0m"
  end

  def bg_brown
    "\e[43m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_magenta
    "\e[45m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end
end
