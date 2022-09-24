const formatTimeMillis = (input) => {
  if (!input) return
  const date = new Date(input)
  let hour = date.getHours()
  let minute = date.getMinutes()
  let second = date.getMilliseconds()
  hour = hour < 10 ? '0' + hour : hour
  minute = minute < 10 ? '0' + minute : minute
  second = second < 10 ? '0' + second : second
  return hour + ':' + minute + ':' + second
}

export { formatTimeMillis }
