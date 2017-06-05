require 'date'

desc "This task is called by the Heroku scheduler add-on"

task :update_tgps => :environment do
    if Time.zone.now.wday == 5 
        puts "Updating AIP TGPs..."
        TerminalGatePrice.import_terminal_gate_prices
        puts "Done."
    else
        puts "Not a Friday: Updating AIP TGPs skipped."
    end
end

task :force_update_tgps => :environment do
    puts "Updating AIP TGPs..."
    TerminalGatePrice.import_terminal_gate_prices
    puts "Done."
end