import Toybox.Lang;

// my magnum opus
class CSV {
    typedef LoadFunc as (Method(i as Number) as ResourceId);
    typedef Entry as interface {
        function initialize(bytes as ByteArray, offset as Number) as Void;
    };
    typedef Factory as (Method(bytes as ByteArray, offset as Number) as Entry);

    private var loadFunc as LoadFunc;
    private var byteArray as ByteArray = []b;
    private var index as Number = -1;
    private var range as [Number, Number] = [-1, -1];
    private var entrySize as Number = -1;
    private var factory as Factory?;

    function initialize(funcId as Symbol, modelFactory as Symbol?) {
        loadFunc = new Lang.Method(Generated, funcId) as LoadFunc;
        if (modelFactory != null) {
            self.factory = new Lang.Method(Models, modelFactory) as CSV.Factory;
        }
    }

    function load(index as Number) as CSV {
        self.index = index;
        if (index < range[0] || range[1] < index) {
            var rez = loadFunc.invoke(index);
            byteArray = Utils.loadByteArray(rez);
            range[0] = Utils.decodeOff64(byteArray, 0, K.META_START_INDEX_SIZE);
            range[1] =
                range[0] +
                Utils.decodeOff64(
                    byteArray,
                    K.META_START_INDEX_SIZE,
                    K.META_NUM_ENTRIES_SIZE
                ) -
                1;
            entrySize = Utils.decodeOff64(
                byteArray,
                K.META_START_INDEX_SIZE + K.META_NUM_ENTRIES_SIZE,
                K.META_ENTRY_LEN_SIZE
            );
        }

        return self;
    }

    function create() as Entry {
        if (factory != null) {
            return factory.invoke(raw(), offset());
        } else {
            return null as Entry;
        }
    }

    private function raw() as ByteArray {
        return byteArray;
    }

    private function offset() as Number {
        if (entrySize == 0) {
            return (
                Utils.getNthVariablePos(byteArray, index) +
                K.VARIABLE_LENGTH_SIZE
            );
        } else {
            return K.META_SIZE + (index - range[0]) * entrySize;
        }
    }

    function string() as String {
        return Utils.getNthString(byteArray, index);
    }
}
