#! /usr/bin/ruby
#-*- coding: utf-8 -*-

require "gnuplot"
require "gsl"
require "csv"

dir = File.dirname(__FILE__)
dat = dir + "/../dat/MonthlyMeanTemperature.csv"

mmt = Hash.new

csv = CSV.open(dat)
months = csv.shift[1..-1]
130.times{ csv.shift } # Discard olds

csv.each do |row|
  year = row[0]
  mmt[year] = Array.new
  12.times{|i| mmt[year][i] = row[i+1].to_f }
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.term   "postscript 12 color"
    plot.output "#{dir}/graph/line01.eps"
    plot.ylabel "Mean Temperature [deg C]"
    plot.key    "top right"
    plot.xtics "(#{months.map{|m| "'#{m}'"}.zip((0..11).to_a).map{|m| m.join ' '}.join ','})"

    mmt.each do |year, vector|
      plot.data << Gnuplot::DataSet.new(vector) do |ds|
        ds.with = "linespoints"
        ds.linewidth = 3
        ds.title = year
      end
    end
  end
end

