require 'nokogiri'

xml_file = File.open("SkillTree.xml")
doc = Nokogiri::XML(xml_file)

puts "$typeid_to_name = {"

doc.xpath("//eveapi/result/rowset/row/rowset[@name='skills']/row").each do |row|
  type_id = row.attribute("typeID")
  type_name= row.attribute("typeName")

  row.xpath('description').each do |description_node|
    description = description_node.text.gsub("'", "")
    puts "\t'#{type_id}' => ['#{type_name}', '#{description}'],"
  end
end

puts "}"





#cal = CalendarFactory.new
#entry = cal.create_entry('Test entry', 'test description', DateTime.new(2012, 10, 7, 12, 11, 22), DateTime.new(2012, 10, 8, 16, 44, 00), true)

xml = "
<?xml version='1.0' encoding='UTF-8'?>
<eveapi version=\"2\">
  <currentTime>2012-10-06 20:20:25</currentTime>
  <result>
    <rowset name=\"skillqueue\" key=\"queuePosition\" columns=\"queuePosition,typeID,level,startSP,endSP,startTime,endTime\">
      <row queuePosition=\"0\" typeID=\"3434\" level=\"2\" startSP=\"750\" endSP=\"4243\" startTime=\"2012-10-07 12:47:27\" endTime=\"2012-10-07 14:43:53\" />
      <row queuePosition=\"1\" typeID=\"3433\" level=\"1\" startSP=\"0\" endSP=\"750\" startTime=\"2012-10-07 14:43:53\" endTime=\"2012-10-07 15:08:47\" />
      <row queuePosition=\"2\" typeID=\"3426\" level=\"5\" startSP=\"45255\" endSP=\"256000\" startTime=\"2012-10-07 15:08:47\" endTime=\"2012-10-12 12:12:57\" />    </rowset>
  </result>
  <cachedUntil>2012-10-06 21:14:24</cachedUntil>
</eveapi>"

#entries = cal.create_events_from_xml(xml)
#puts entries

#<?xml version='1.0' encoding='UTF-8'?>
#<eveapi version="2">
#  <currentTime>2012-10-07 12:48:40</currentTime>
#  <result>
#    <rowset name="skillqueue" key="queuePosition" columns="queuePosition,typeID,level,startSP,endSP,startTime,endTime">
#      <row queuePosition="0" typeID="3434" level="2" startSP="750" endSP="4243" startTime="2012-10-07 12:47:27" endTime="2012-10-07 14:43:53" />
#      <row queuePosition="1" typeID="3433" level="1" startSP="0" endSP="750" startTime="2012-10-07 14:43:53" endTime="2012-10-07 15:08:47" />
#      <row queuePosition="2" typeID="3426" level="5" startSP="45255" endSP="256000" startTime="2012-10-07 15:08:47" endTime="2012-10-12 12:12:57" />
#    </rowset>
#  </result>
#  <cachedUntil>2012-10-07 13:45:40</cachedUntil>
#</eveapi>

    # https://api.eveonline.com/char/SkillQueue.xml.aspx?keyID=1364274&vCode=5r8FRlm9rE5jAgg6sY71dtt6UnwoqbTN0Xm3EymPQsU0QUZwRMrOvqnRXyBPYLDD&characterID=1700742529
     # http://localhost:4567/skillqueue/1364274/5r8FRlm9rE5jAgg6sY71dtt6UnwoqbTN0Xm3EymPQsU0QUZwRMrOvqnRXyBPYLDD/1700742529/skillqueue.ics
