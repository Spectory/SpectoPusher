/* global describe, it, before */

import chai from 'chai';
import sinon from 'sinon';
import SpectoPusher from '../src/index';
import * as Phoenix from 'phoenix-socket';

const expect = chai.expect;
const noop = () => {};
const dummySocket = {
  connect: noop,
  onOpen: noop,
  onError: noop,
  onClose: noop,
};

describe('SpectoPusher', () => {
  let subject;
  const PARAMS = Object.freeze({
    url: 'server.url',
  });

  beforeEach(() => {
    subject = new SpectoPusher(PARAMS);
  });

  it('constructor', () => {
    expect(subject.URL).to.equal(PARAMS.url);
    expect(subject.socket).to.equal(null);
    expect(subject.channels).to.eql({});
    expect(subject.debug).to.equal(false);
  });

  describe('connect', () => {
    beforeEach(() => {
      sinon.stub(Phoenix, 'Socket').returns(dummySocket);
      subject.socket = {connect: () => {}};
    });

    it('should create a socket', () => {
      subject.connect();
      expect(subject.socket).to.eql(dummySocket);
    });
  });

  describe('join', () => {
    beforeEach(() => {
      const receiveStub = sinon.stub().returns({receive: noop});
      const dummyChannel = {
        join: () => ({receive: receiveStub}),
        on: sinon.spy(),
      };
      const channelStub = sinon.stub();
      channelStub.returns(dummyChannel);
      subject.socket = {channel: channelStub};
    });

    it('should add channel', () => {
      const onMsg = noop;

      subject.join('topic', {onMsg});
      expect(subject.channels.topic).to.be.ok;
      expect(subject.channels.topic.on.calledWith('new_msg', onMsg))
          .to.equal(true);
    });
  });

  describe('send', () => {
    it('should push message to channel', () => {
      const push = sinon.spy();
      subject.channels.someTopic = {push};

      subject.send('someTopic', 'some message');
      expect(subject.channels.someTopic.push
          .calledWith('new_msg', {body: 'some message'})).to.equal(true);
    });
  });

  describe('leave', () => {
    it('should leave channel', () => {
      const receive = sinon.spy();
      const onLeave = noop;
      const leave = () => ({receive});
      subject.channels.someTopic = {leave};

      subject.leave('someTopic', {onLeave});
      expect(receive.calledWith('ok', onLeave)).to.equal(true);
      expect(subject.channels.someTopic).to.equal(undefined);
    });
  });
});
