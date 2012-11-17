#! /usr/bin/ruby
#-*- coding: utf-8 -*-

require "gnuplot"
require "gsl"
require "csv"

dir = File.dirname(__FILE__)
dat = dir + "/../dat/MonthlyMeanTemperature.csv"

nov = Array.new
dec = Array.new
csv = CSV.open(dat, :headers => :first_row)
csv.each do |row|
  nov << row["Nov."]
  dec << row["Dec."]
end

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.term   "postscript 12 color"
    plot.output "#{dir}/graph/dot01.eps"
    plot.title  "Mean Temperature [deg C]"
    plot.xlabel "November"
    plot.ylabel "December"
    plot.xrange "[0:]"
    plot.yrange "[0:]"

    plot.data << Gnuplot::DataSet.new([nov, dec]) do |ds|
      ds.with = "points"
      ds.title = "notitle"
    end
  end
end

