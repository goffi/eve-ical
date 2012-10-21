require 'icalendar'
require 'date'
require 'nokogiri'
require_relative 'skillmap'

class SkillQueue

  def initialize(key_id, vcode, character_id)
    queue_xml = get_skill_queued(key_id, vcode, character_id)
    @skill_queue = parse_skill_queue(queue_xml)
    @calendar = Icalendar::Calendar.new
  end


  def calendar
    @calendar.to_ical
  end


  def get_skill_queued(key_id, vcode, character_id)
     http_client = HTTPClient.new
     http_client.get_content("https://api.eveonline.com/char/SkillQueue.xml.aspx?keyID=#{key_id}&vCode=#{vcode}&&characterID=#{character_id}")
  end


  def parse_skill_queue(queue_xml)
    skill_queue = []
    doc = Nokogiri::XML(queue_xml)
    doc.xpath('//eveapi/result/rowset/row').each do |row|
      type = row.attribute("typeID").text
      level = row.attribute("level").text
      start_sp = row.attribute("startSP").text.to_i
      end_sp = row.attribute("endSP").text.to_i
      start_time = parse_time row.attribute("startTime").text
      end_time = parse_time  row.attribute("endTime").text

      skill_name = $typeid_to_name[type][0]
      description = $typeid_to_name[type][1]

      skill_queue <<
          {
              :name => skill_name,
              :level => level,
              :start_sp => start_sp,
              :end_sp => end_sp,
              :dt_start => start_time,
              :dt_end => end_time,
              :description => description
          }
    end
    skill_queue
  end


  def create_events
    @skill_queue.each do |skill|
      description = "#{skill[:description]}\n\nSkill points\nStart: #{skill[:start_sp]} End: #{skill[:end_sp]}"
      title = "#{skill[:name]} lvl. #{skill[:level]}"
      create_entry(title, description, skill[:dt_start], skill[:dt_end], false)
    end
  end


  def create_reminder
    last = @skill_queue.last

    end_time = last[:dt_end] + (5.0/24/60)
    create_entry("Skill queue empty", "Skill queue empty", last[:dt_end], end_time , true)
  end


  def create_entry(summary_text, description_text, start_time, end_time, set_reminder)
    @calendar.event do
      dtstart     start_time
      dtend       end_time
      summary     summary_text
      description description_text
      klass       "PRIVATE"
      if set_reminder
          alarm do
            action        "DISPLAY"
            summary       "Skill queue empty"
            trigger       "-P0DT0H5M0S"
          end
      end
    end
  end

  def id_to_name(type)
     typeid_to_name[type][0]
   end


   def parse_time(date_time)
     format = "%Y-%m-%d %H:%M:%S" # e.g 2012-10-04 21:29:57
     DateTime.strptime(date_time, format)
   end
end
