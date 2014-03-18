require 'spec_helper'

describe ECDSA::Point do
  let(:group) do
    ECDSA::Group::Secp256k1
  end

  describe 'multiplty_by_scalar' do
    it 'does not give infinity when we multiply the generator of secp256k1 by a number less than the order' do
      # this test was added to fix a particular bug
      k = 2
      expect(k).to be < group.order
      point = group.generator.multiply_by_scalar(k)
      expect(point).to_not be_infinity
    end
  end

  describe 'add_to_point' do
    context 'when adding point + infinity' do
      it 'returns the point' do
        expect(group.generator.add_to_point(group.infinity_point)).to eq group.generator
      end
    end

    context 'when adding infinity + point' do
      it 'returns the point' do
        expect(group.infinity_point.add_to_point(group.generator)).to eq group.generator
      end
    end
  end

  describe 'negate' do
    context 'for infinity' do
      it 'returns infinity' do
        expect(group.infinity_point.negate).to eq group.infinity_point
      end
    end

    context 'for non-infinity' do
      it 'returns a point with same x coordinate but negated y coordinate' do
        n = group.generator.negate
        expect(n.x).to eq group.generator.x
        expect(n.y).to eq group.field.mod(-group.generator.y)
      end
    end
  end

  describe 'double' do
    it 'can double the generator of secp256k1' do
      point = group.generator.double
      expect(point).to_not be_infinity
    end
  end

  describe '#inspect' do
    it 'shows the coordinates if the point has them' do
      expect(group.generator.inspect).to eq '#<ECDSA::Point: secp256k1, ' \
        '0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798, ' \
        '0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8>'
    end

    it 'shows infinity if the point is infinity' do
      expect(group.infinity_point.inspect).to eq '#<ECDSA::Point: secp256k1, infinity>'
    end
  end
end
