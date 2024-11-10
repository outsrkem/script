const obj = {
    arr: [],
    a:4,
}
obj.sub = obj
obj.arr.push(obj)

// 深度克隆
function deepClone(value) {
    const cache = new Map();
    function _deepClone(value) {
        if (value === null || typeof value !== 'object') {
            return value;
        }
        if (cache.has(value)) {
            return cache.get(value);
        }
        const result = Array.isArray(value) ? [] : {};
        cache.set(value, result)
        for (const key in value) {
            result[key] = _deepClone(value[key]);
        }
        return result; 
    }
    return _deepClone(value);
}

const newObj = deepClone(obj)
console.log(newObj.arr !== obj.arr) // true
console.log(newObj.sub !== obj.sub) // true
console.log(newObj.arr[0] !== obj) // true
console.log(newObj.arr[0] === newObj) // true
