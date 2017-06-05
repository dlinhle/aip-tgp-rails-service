class TerminalGatePrice < ApplicationRecord
       
    def self.import_terminal_gate_prices
        # Clear the database
        Rails.logger.info("Commencing new TGP import")
        Rails.logger.info("Clearing database")
        TerminalGatePrice.delete_all
        
        xls = TerminalGatePrice.ingest_latest_tgp_xls
        
        fuels = ['diesel', 'petrol']
        
        fuels.each do |fuel|
            Rails.logger.info("Importing #{fuel} TGP sheet")
            tgp_sheet = xls.sheet("#{fuel.capitalize} TGP")
            sheet_sequence = TerminalGatePrice.xls_header_row_sequence(tgp_sheet)
            
            tgp_sheet.each do |row|
                if row[1].is_a? Numeric
                    TerminalGatePrice.write_xls_row_to_db(fuel, row, sheet_sequence)    
                end
            end
        end
        
        return true
    end
    
    def self.to_csv
        CSV.generate do |csv|
            csv << column_names
            all.each do |tgp|
                csv << tgp.attributes.values_at(*column_names)
            end
        end
    end
    
    private
    
    def self.latest_xls_url
        date_today = Time.zone.now
        last_friday_date = date_today.beginning_of_week(:friday)
        link_date_string = last_friday_date.strftime("%d-%b-%Y")
        link = "http://www.aip.com.au/pricing/pdf/AIP_TGP_Data_#{link_date_string}.xls"
        
        return link
    end
    
    def self.ingest_latest_tgp_xls
        latest_xls_url = TerminalGatePrice.latest_xls_url
        
        # Download the latest XLS
        Rails.logger.info("Opening XLS URL via roo gem: #{latest_xls_url}")
        xls = Roo::Spreadsheet.open(latest_xls_url)
        
        return xls
    end
    
    def self.xls_header_row_sequence(tgp_sheet)
        first_row = TerminalGatePrice.xls_first_row(tgp_sheet)
        
        sequence = []
        
        first_row.each do |c|
            parsed_c = c.downcase.gsub("\n",'_')
            
            sequence.push(parsed_c) if self.valid_locations.include?(parsed_c)
        end
        
        
    end
    
    def self.xls_first_row(tgp_sheet)
        first_row_number = tgp_sheet.first_row
        first_row = tgp_sheet.row(first_row_number)
        
        return first_row
    end
    
    def self.valid_locations
        ['sydney', 'melbourne', 'brisbane', 'adelaide', 'perth', 'darwin', 'hobart', 'national_average']
    end
    
    def self.write_xls_row_to_db(fuel, xls_row, column_sequence)
        date = Date.new(1899,12,30) + xls_row[0].days
        
        existing_record = TerminalGatePrice.where("date = ?", date).first
        
        if existing_record.nil?
            tgps = TerminalGatePrice.new
            tgps.date = date
        else
            tgps = existing_record
        end
        
        i = -1
        
        xls_row.each do |c|
            tgps.send("#{fuel}_#{TerminalGatePrice.valid_locations[i]}=", c) unless i < 0
            i += 1
        end
        
        tgps.save
    end
        
end
