// import data from './get-group-by-id-example.json'

export const fetchData = (url) => {
  return fetch(url, {
    method: 'GET'
  }).then((response) => {
    return response.json()
  })
}

export const getGroupById = async (groupId) => {
  try {
    return await fetchData(`https://hungry.mymidjourney.ru/api/groups/get/${groupId}`)
    // return data;
  } catch (e) {
    console.error(e)
  }
}