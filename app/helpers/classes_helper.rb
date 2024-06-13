module ClassesHelper
    def japanese_wday(date)
        wdays = ["日", "月", "火", "水", "木", "金", "土"]
        wdays[date.wday]
    end
end
