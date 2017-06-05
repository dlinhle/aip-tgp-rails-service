desc "This task is called by the Heroku scheduler add-on"

task :update_tgps do
  puts "Update AIP TGPs"
  TerminalGatePrice.import_terminal_gate_prices
  puts "Done."
end