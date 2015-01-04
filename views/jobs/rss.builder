xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Datasektionens Jobbportal"
    xml.description "Htta ett jobb som passar dig."
    xml.link "http://wwww.djobb.se"

    @jobs.each do |job|
      xml.item do
        xml.title job.title
        xml.link "http://www.djobb.se/jobs/#{job.id}"
        xml.description job.short_description
        xml.pubDate Time.parse(job.starttime.to_s).rfc822()
        xml.guid "http://www.djobb.se/jobs/#{job.id}"
      end
    end
  end
end
