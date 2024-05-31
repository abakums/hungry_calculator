// import data from './get-group-by-id-example.json'

export const fetchData = (url) => {
  console.log(`Получаем данные по url: ${url}`);
  
  return fetch(url, {
    method: 'GET'
  }).then((response) => {
    if (!response.ok) { throw new Error(`Ошибка HTTP! Статус: ${response.status}`); }
    return response.json()
  }).catch(e => {
    console.error(`Ошибка получения данных по url: ${url}. Ошибка: ${e}`);
    throw e;
  });
}

export const getGroupById = async (groupId) => {
  try {
    console.log(`Получаем данные по группе ID=${groupId}`);
    const result = await fetchData(`http://88.218.61.170/api/groups/get/${groupId}`);
    console.log(`Получены данные по группе ID=${groupId}`);
    return result;
  } catch (e) {
    console.error(`Ошибка при получении данных по группе ID=${groupId}. Ошибка: ${e}`);
  }
}